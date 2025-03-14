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
        data = e.envs
    }
    secret
}

envInjector = lambda envs: Envs, deploy: appsv1.Deployment {
    """Inject envs to Deployment"""
    _result: [appsv1.Deployment] = []
    if deploy.kind != "Deployment":
        _result = [deploy]
    else:
        secretEnv = [{
            name = k
            secret = v
        } for k, v in envs.envs]
        deploy.spec.template.spec.containers[0].env = secretEnv
        _result = [deploy]
    _result
}
