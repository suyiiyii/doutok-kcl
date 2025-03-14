import k8s.api.apps.v1 as appsv1
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
        stringData = e.envs
    }
    [secret]
}

envInjector = lambda envs: Envs, deploy {
    """Inject envs to Deployment"""
    _result = {}
    if deploy.kind != "Deployment":
        _result = deploy
    else:
        secretEnv: [corev1.EnvVar] = [{
            name = k
            valueFrom = {
                secretKeyRef = {
                    name = "app-secret"
                    key = k
                }
            }
        } for k, v in envs.envs]
        deploy.spec.template.spec.containers[0].env = secretEnv
        _result = deploy
    _result
}
