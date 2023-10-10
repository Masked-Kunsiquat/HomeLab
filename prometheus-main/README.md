YAML file for main prometheus instance
- hosted in a Proxmox LXC
- gathering info for following services:
    - proxmox
    - docker network (and the containers)
- funnels into Grafana for dashboards/visuals (graphs, tables, etc.)