.PHONY: setup get clean gen gen-watch analyze format test check run db-push db-reset

setup:
	cp .env.example .env || true
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs

get:
	flutter pub get

clean:
	flutter clean

gen:
	dart run build_runner build --delete-conflicting-outputs

gen-watch:
	dart run build_runner watch --delete-conflicting-outputs

analyze:
	flutter analyze

format:
	dart format lib/ test/

test:
	flutter test

check: analyze format test

run:
	flutter run

db-push:
	supabase db push

db-reset:
	supabase db reset
