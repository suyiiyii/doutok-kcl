import cert_manager.v1

issuer = v1.Issuer {
    apiVersion = "cert-manager.io/v1"
    kind = "Issuer"
    metadata = {
        name = "letsencrypt"
    }
    spec = {
        acme = {
            email = "suyiiyii@gmail.com"
            server = "https://acme-v02.api.letsencrypt.org/directory"
            privateKeySecretRef = {
                name = "letsencrypt"
            }
            solvers = [{
                http01 = {
                    ingress = {
                        class = "traefik"
                    }
                }
            }]
        }
    }
}
