import k8s.api.core.v1 as corev1

schema Envs:
    """Env schema"""
    envs: {str:str}

envSecretRender = lambda e: Envs {
    secret = corev1.Secret {
        apiVersion = "v1"
        kind = "Secret"
        metadata = {
            name = "app-sevret"
        }
        data = e.envs
    }
    secret
}
