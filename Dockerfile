FROM dart:2.17.6-sdk as builder

RUN mkdir -p /app
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart compile exe ./bin/cucumber_google_sheets.dart -o ./bin/cucumber_google_sheets

FROM subfuzion/dart-scratch
COPY --from=builder /app/bin/cucumber_google_sheets /app/cucumber_google_sheets
ENTRYPOINT ["/app/cucumber_google_sheets"]
