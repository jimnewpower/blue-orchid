clean:
	@-rm -rf archive bin
	@-rm -f deploy/archive/main
	@-rm -f deploy/archive/conjur-dev.pem
	@-rm -f deploy/main
	@-rm -f deploy/conjur-dev.pem
	@-rm -f deploy/main.zip
policy:
	sh add_policy.sh
check:
	sh check_policy.sh
build:
	sh build.sh
lambda:
	@-mkdir -p config/env
	sh deploy.sh
apply:
	cd deploy && terraform apply
help:
	@echo "clean     clean up"
	@echo "policy    add policy"
	@echo "check     check policy"
	@echo "build     build lambda"
	@echo "lambda    deploy lambda"
	@echo "apply     apply terraform"
	@echo "help      help"