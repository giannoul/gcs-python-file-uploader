
.PHONY: minikube-start
minikube-start:
	minikube start --kubernetes-version=v1.25.11
	minikube addons enable ingress

.PHONY: minikube-destroy
minikube-destroy:
	minikube stop
	minikube delete

.PHONY: apply-manifests
apply-manifests:
	kubectl apply -f manifests

.PHONY: .create-tmp-file
.create-tmp-file:
	echo "Hello there!!" > /tmp/uploadme.txt

.PHONY: upload-file
upload-file: .create-tmp-file
	curl http://$(shell minikube ip)/api/upload-random -F "file=@/tmp/uploadme.txt"
