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


# base.appRender(a)
manifests.yaml_stream([base.appRender(a) for a in base.App.instances()])
