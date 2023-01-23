REPO=artemis-server
TIMESTAMP=tmp-$(shell date +%s )
DFILE=artemis-server/deployment.yml
SFILE=artemis-server/svc.yml
IFILE=artemis-server/ing.yml
VERSION=v1
TEST_PATH=Documents/projects/microservices-chat-app/artemis-server

.PHONY: update
update:
		@eval $$(minikube docker-env) ;\
		docker image build -t $(REPO):$(VERSION) -f Dockerfile .
		kubectl set image -n $(NSPACE) deployment/$(REPO) *=$(REPO):$(TIMESTAMP)

.PHONY: delete
delete:
		kubectl delete -n $(NSPACE) deployment,service $(REPO)

.PHONY: create
create:
		@eval $$(minikube docker-env) ;\
		docker image build -t $(REPO):$(VERSION) -f Dockerfile .
		kubectl create -f $(DFILE) -n $(NSPACE)
		kubectl create -f $(SFILE) -n $(NSPACE)

.PHONY: remote
remote:
		rsync -Pva --exclude build --exclude=".*" --delete . $(REMOTE_SERVER):$(TEST_PATH)
		ssh -t -l $(REMOTE_USER) $(REMOTE_SERVER) "cd ${TEST_PATH} ; bash --login" < /dev/tty
