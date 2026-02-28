# ============================================================================
# shells/devops.nix - DevOps & Infrastructure Shell
# ============================================================================
# For when you need to wrangle clusters, provision infra, or debug
# containers. This licks together Terraform, Ansible, k8s tools, and
# container runtimes into one convenient shell.
#
# Usage: nix develop /path/to/nixos-config#devops
# ============================================================================
{ pkgs }:

pkgs.mkShell {
  name = "devops";

  buildInputs = with pkgs; [
    # -- Containers ---------------------------------------------------------
    docker
    docker-compose
    podman
    buildah
    skopeo             # container image inspection

    # -- Infrastructure as Code ---------------------------------------------
    terraform
    ansible

    # -- Kubernetes ---------------------------------------------------------
    kubectl
    helm
    k9s                # terminal UI for k8s clusters
    kubectx            # switch contexts/namespaces fast
    stern              # multi-pod log tailing

    # -- Cloud CLIs ---------------------------------------------------------
    awscli2
    google-cloud-sdk

    # -- Secrets & security -------------------------------------------------
    sops               # encrypted secrets management
    age                # modern encryption tool

    # -- Networking & debugging ---------------------------------------------
    curl
    wget
    jq
    yq-go              # like jq but for YAML
    httpie             # human-friendly HTTP client

    # -- General tooling ----------------------------------------------------
    git
    direnv
  ];

  shellHook = ''
    echo ""
    echo "  devops shell"
    echo "  ============"
    echo "  docker / podman / buildah / skopeo"
    echo "  terraform / ansible"
    echo "  kubectl / helm / k9s / kubectx / stern"
    echo "  aws / gcloud / sops / age"
    echo ""
    echo "  Tip: use 'k9s' for a slick terminal k8s dashboard"
    echo ""
  '';
}
