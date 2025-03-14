import base
import yaml
import manifests

apps = [
    base.App {
        name = "nginxxx"
        replicas = 2
        image = "library/nginx"
        port = 80
    }
    base.App {
        name = "caddyy"
        replicas = 2
        image = "library/caddy"
        port = 80
    }
]

envs = base.Envs {
    envs = {
        "APP_VAR": "varvalue"
        "APP_SECRET": "secretvalue"
    }
}

deploys = sum([base.appRender(a) for a in apps], [])
# print(yaml.encode(deploys))
apps_manifests = [base.envInjector(envs, deploy) for deploy in deploys]

env_manifests = [base.envSecretRender(a) for a in base.Envs.instances()]
# base.appRender(a)
manifests.yaml_stream([apps_manifests, env_manifests])
