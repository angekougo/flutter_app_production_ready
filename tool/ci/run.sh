#!/usr/bin/env bash
# Lance une commande de CI. En cas d'échec, publie les dernières lignes de
# sortie en annotation GitHub : l'erreur est lisible depuis l'onglet
# « Summary » du run sans ouvrir les logs complets.
#
#   tool/ci/run.sh "Titre" commande [arguments…]
set -uo pipefail

title="$1"
shift
log="$(mktemp)"

"$@" 2>&1 | tee "$log"
status=${PIPESTATUS[0]}

if [ "$status" -ne 0 ]; then
  # Échappement des annotations : % → %25, retour à la ligne → %0A.
  excerpt="$(grep -v '^\s*$' "$log" | tail -n 40 | sed 's/%/%25/g' | awk '{printf "%s%%0A", $0}')"
  echo "::error title=${title}::${excerpt}"
fi
exit "$status"
