secret=$1
path=.data.password
isString=1

if [ -z $secret ]; then echo "you must pass the secret name"; fi

while true; do
  case "$1" in
    --path) path="$2"; shift 2 ;;
    --no-string) isString=0; shift ;;
    "" | -- ) break ;;
    *) shift; continue ;;
  esac
done

extracted=$(kubectl get secret $secret -o json | jq "$path")
if [ "$isString" -eq 1 ]; then
  extracted=$(echo $extracted | sed -E 's/^"|"$//g');
fi
echo "$extracted" | base64 -d
