import k8s.api.networking.v1 as networkingv1

schema HTTPService:
    """http service"""
    service: str
    domain: str

httpServiceRender = lambda h: HTTPService {
    """Render http service to Ingress"""
    ingress = networkingv1.Ingress {
        apiVersion = "networking.k8s.io/v1"
        kind = "Ingress"
        metadata = {
            name = h.service
        }
        spec = {
            rules = [{
                host = h.domain
                http = {
                    paths = [{
                        path = "/"
                        pathType = "Prefix"
                        backend = {
                            service = {
                                name = h.service
                                port = {
                                    number = 80
                                }
                            }
                        }
                    }]
                }
            }]
        }
    }
    [ingress]
}

certInjector = lambda input: networkingv1.Ingress | any {
    """Inject cert to Ingress"""
    _result: any = {}
    if input.kind != "Ingress":
        _result = input
    else:
        ingress: networkingv1.Ingress = input as networkingv1.Ingress
        print(ingress)
        ingress.metadata.annotations = {"cert-manager.io/issuer" = "letsencrypt"}
        ingress.spec.tls = [{
            hosts = [r.host for r in ingress.spec.rules]
            secretName = "tls-" + ingress.metadata.name
        }]
        _result = ingress
    _result
}

httpServiceRefine = lambda h: HTTPService {
    ingress = httpServiceRender(h)
    ingress2 = certInjector(ingress[0])
    ingress2
}
