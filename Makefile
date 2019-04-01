IMAGE_NAME     := react-web
CUCUMBER_IMAGE_NAME     := react-web-tests

start:
	@yarn run start

cucumber-test:
	@cucumber --fail-fast --tags 'not @ignore'

# Start the cucumber capybara e2e tests
test-e2e:
	@docker-compose exec $(CUCUMBER_IMAGE_NAME) make cucumber-test

.started:
	@docker-compose build
	@docker-compose up -d
	@touch .started
	@echo "Docker containers are now running."

start-docker-image: .started

# Alias for watch
serve: watch

# Start the website on port 3000
watch: .started
	@docker-compose exec $(IMAGE_NAME) make install
	@docker-compose exec $(IMAGE_NAME) yarn run start

stop:
	@docker-compose kill
	@docker-compose stop
	@docker-compose down
	@docker-compose rm -f
-@rm .started
