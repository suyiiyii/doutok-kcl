import base

import manifests

base.App {
    name = "myapp"
    replicas = 2
    image = "myimage"
    port = 8080
}
base.App {
    name = "myapp122"
    replicas = 2
    image = "myimage"
    port = 8080
}

base.Envs {
    envs = {
        "key1": "value1"
        "key2": "value2"
    }
}

apps_manifests = [base.appRender(a) for a in base.App.instances()]

env_manifests = [base.envSecretRender(a) for a in base.Envs.instances()]
# base.appRender(a)
manifests.yaml_stream([apps_manifests, env_manifests])
