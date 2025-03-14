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
