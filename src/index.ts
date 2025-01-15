import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { Redis } from "ioredis";

const app = new Hono();

const redis = new Redis("redis://default:password@redis:6379/0");

app.get("/", async (c) => {
  console.log(redis.status);

  const res = await redis.ping();
  console.log(res);

  return c.text("Hello Hono!");
});

const port = 3000;
console.log(`Server is running on http://localhost:${port}`);

serve({
  fetch: app.fetch,
  port,
});
