import k8s.api.apps.v1 as appsv1
import k8s.api.core.v1 as corev1

schema App:
    """App schema"""
    name: str
    replicas: int = 1
    image: str
    port: int

appRender = lambda a: App {
    deployment = appsv1.Deployment {
        apiVersion = "apps/v1"
        kind = "Deployment"
        metadata = {
            name = a.name
            labels.app = a.name
        }
        spec = {
            replicas = a.replicas
            selector.matchLabels = metadata.labels
            template.metadata.labels = metadata.labels
            template.spec.containers = [
                {
                    name = a.name
                    image = a.image
                    ports = [{containerPort = a.port}]
                }
            ]
        }
    }
    service = corev1.Service {
        apiVersion = "v1"
        kind = "Service"
        metadata = {
            name = a.name
        }
        spec = {
            selector.app = a.name
            ports = [{port = a.port, targetPort = a.port}]
        }
    }
    [deployment, service]
}
