FROM amazon/aws-lambda-nodejs:16
WORKDIR /app

# Lambda Web Adapterのインストール
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.5.0 /lambda-adapter /opt/extensions/lambda-adapter
ENV PORT=3000
ENV NODE_ENV=production

COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static


# ベースイメージ変更に伴う調整
ENTRYPOINT ["node"]
CMD ["server.js"]