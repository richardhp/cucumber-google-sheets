FROM dart:2.17.6-sdk as builder

# Build
RUN mkdir -p /app
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart compile exe ./bin/cucumber_google_sheets.dart -o ./bin/cucumber_google_sheets

FROM scratch as runner
COPY --from=builder /runtime/ /
COPY --from=builder /app/bin/cucumber_google_sheets /app/cucumber_google_sheets
ENTRYPOINT ["/app/cucumber_google_sheets"]
