-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
BEGIN TRANSACTION;

DROP TABLE IF EXISTS "comments";
DROP TABLE IF EXISTS "likes";
DROP TABLE IF EXISTS "snippet_tags";
DROP TABLE IF EXISTS "tags";
DROP TABLE IF EXISTS "snippets";
DROP TABLE IF EXISTS "languages";
DROP TABLE IF EXISTS "users";

COMMIT;

BEGIN TRANSACTION;

-- Users
CREATE TABLE "users" (
  "id" SERIAL,
  "name" VARCHAR(100) NOT NULL,
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "password_hash" TEXT NOT NULL,
  "created_at" TIMESTAMPTZ DEFAULT now(), -- TIMESTAMP with Time Zone
  PRIMARY KEY("id")
);

-- Languages
CREATE TABLE "languages" (
  "id" SERIAL,
  "name" VARCHAR(100) NOT NULL,
  "version" VARCHAR(50),
  PRIMARY KEY("id")
);

-- Snippets
CREATE TABLE "snippets" (
  "id" SERIAL,
  "title" VARCHAR(255),
  "description" TEXT,
  "code" TEXT NOT NULL,
  "visibility" VARCHAR(10) NOT NULL CHECK("visibility" IN ('private','public')),
  "created_at" TIMESTAMPTZ DEFAULT now(),
  "user_id" INTEGER NOT NULL,
  "language_id" INTEGER,
  PRIMARY KEY("id"),
  FOREIGN KEY("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
  FOREIGN KEY("language_id") REFERENCES "languages"("id")
);

-- Tags & relations
CREATE TABLE "tags" (
  "id" SERIAL,
  "name" VARCHAR(50) UNIQUE NOT NULL,
  PRIMARY KEY("id")
);

CREATE TABLE "snippet_tags" (
  "snippet_id" INTEGER,
  "tag_id" INTEGER,
  PRIMARY KEY ("snippet_id", "tag_id"),
  FOREIGN KEY ("snippet_id") REFERENCES "snippets"("id") ON DELETE CASCADE,
  FOREIGN KEY ("tag_id") REFERENCES "tags"("id")
);

-- Likes
CREATE TABLE "likes" (
  "id" SERIAL,
  "user_id" INTEGER,
  "snippet_id" INTEGER,
  "created_at" TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY("id"),
  FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE,
  FOREIGN KEY ("snippet_id") REFERENCES "snippets"("id") ON DELETE CASCADE,
  UNIQUE ("user_id", "snippet_id")
);

-- Comments
CREATE TABLE "comments" (
  "id" SERIAL,
  "user_id" INTEGER,
  "snippet_id" INTEGER,
  "content" TEXT NOT NULL,
  "created_at" TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY("id"),
  FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL,
  FOREIGN KEY ("snippet_id") REFERENCES "snippets"("id") ON DELETE CASCADE
);

COMMIT;

--------------------------------------------------------------------------------------------

BEGIN TRANSACTION;

-- INDEXES
-- Indexes for users
CREATE INDEX "index_users_email" ON "users"("email");
CREATE INDEX "index_users_name" ON "users"("name");

-- Index for snippets
CREATE INDEX "index_snippets_title" ON "snippets"("title");

-- Indexes for likes and comments
CREATE INDEX "index_likes_snippet_id" ON "likes"("snippet_id");
CREATE INDEX "index_comments_snippet_id" ON "comments"("snippet_id");

COMMIT;
--------------------------------------------------------------------------------------------
-- Insert fake data for database testing

-- =========================
-- 30 users
-- =========================
BEGIN TRANSACTION;

INSERT INTO "users" ("name", "email", "password_hash", "created_at") VALUES
('Ariel Dev', 'ariel.dev@example.com', 'hash_pw_1', now() - INTERVAL '30 days'),
('BiancaCoder', 'bianca@example.com', 'hash_pw_2', now() - INTERVAL '29 days'),
('Carlos42', 'carlos@example.com', 'hash_pw_3', now() - INTERVAL '28 days'),
('DoraFullstack', 'dora@example.com', 'hash_pw_4', now() - INTERVAL '27 days'),
('Ezequiel', 'ezequiel@example.com', 'hash_pw_5', now() - INTERVAL '26 days'),
('Fratello', 'fratello@example.com', 'hash_pw_6', now() - INTERVAL '25 days'),
('GinaFront', 'gina@example.com', 'hash_pw_7', now() - INTERVAL '24 days'),
('HectorOps', 'hector@example.com', 'hash_pw_8', now() - INTERVAL '23 days'),
('IreneQA', 'irene@example.com', 'hash_pw_9', now() - INTERVAL '22 days'),
('Joaquin', 'joaquin@example.com', 'hash_pw_10', now() - INTERVAL '21 days'),
('Karla', 'karla@example.com', 'hash_pw_11', now() - INTERVAL '20 days'),
('LeoBackend', 'leo@example.com', 'hash_pw_12', now() - INTERVAL '19 days'),
('Marta', 'marta@example.com', 'hash_pw_13', now() - INTERVAL '18 days'),
('Nico', 'nico@example.com', 'hash_pw_14', now() - INTERVAL '17 days'),
('Olga', 'olga@example.com', 'hash_pw_15', now() - INTERVAL '16 days'),
('Pablo', 'pablo@example.com', 'hash_pw_16', now() - INTERVAL '15 days'),
('Queta', 'queta@example.com', 'hash_pw_17', now() - INTERVAL '14 days'),
('Ramon', 'ramon@example.com', 'hash_pw_18', now() - INTERVAL '13 days'),
('Sofia', 'sofia@example.com', 'hash_pw_19', now() - INTERVAL '12 days'),
('Tomas', 'tomas@example.com', 'hash_pw_20', now() - INTERVAL '11 days'),
('UnaDev', 'una@example.com', 'hash_pw_21', now() - INTERVAL '10 days'),
('Valen', 'valen@example.com', 'hash_pw_22', now() - INTERVAL '9 days'),
('Willy', 'willy@example.com', 'hash_pw_23', now() - INTERVAL '8 days'),
('Ximena', 'ximena@example.com', 'hash_pw_24', now() - INTERVAL '7 days'),
('Yago', 'yago@example.com', 'hash_pw_25', now() - INTERVAL '6 days'),
('Zoe', 'zoe@example.com', 'hash_pw_26', now() - INTERVAL '5 days'),
('Alan', 'alan@example.com', 'hash_pw_27', now() - INTERVAL '4 days'),
('Belen', 'belen@example.com', 'hash_pw_28', now() - INTERVAL '3 days'),
('Ciro', 'ciro@example.com', 'hash_pw_29', now() - INTERVAL '2 days'),
('Dana', 'dana@example.com', 'hash_pw_30', now() - INTERVAL '1 day');

COMMIT;

-- =========================
-- 30 languages
-- =========================

BEGIN TRANSACTION; 

INSERT INTO "languages" ("name", "version") VALUES
('Python', '3.10'),
('JavaScript', 'ES2021'),
('TypeScript', '4.9'),
('Java', '17'),
('C#', '10'),
('Go', '1.21'),
('Ruby', '3.1'),
('PHP', '8.1'),
('Kotlin', '1.8'),
('Rust', '1.68'),
('SQL', 'PostgreSQL dialect'),
('Bash', '5.1'),
('C++', '20'),
('HTML', '5'),
('CSS', '3'),
('Swift', '5.7'),
('Shell', 'sh'),
('Dockerfile', '1.0'),
('YAML', '1.2'),
('GraphQL', 'SDL'),
('Scala', '2.13'),
('Perl', '5.34'),
('Elixir', '1.14'),
('Haskell', '8.10'),
('R', '4.2'),
('Lua', '5.4'),
('MATLAB', 'R2023a'),
('Objective-C', '2.0'),
('Dart', '3.0'),
('C', '11');

COMMIT;

-- =========================
-- 30 tags
-- =========================

BEGIN TRANSACTION;

INSERT INTO "tags" ("name") VALUES
('auth'),
('db'),
('sql'),
('api'),
('regex'),
('performance'),
('docker'),
('kubernetes'),
('testing'),
('security'),
('frontend'),
('backend'),
('ci/cd'),
('design-patterns'),
('error-handling'),
('optimization'),
('devops'),
('graphql'),
('rest'),
('authentication'),
('authorization'),
('cli'),
('logging'),
('monitoring'),
('css'),
('html'),
('javascript'),
('python'),
('typescript'),
('example');

BEGIN TRANSACTION;

-- =========================
-- 30 snippets
-- =========================
-- Use $$ to avoid escaping single quotes in code text

BEGIN TRANSACTION;

INSERT INTO "snippets" ("title", "description", "code", "visibility", "created_at", "user_id", "language_id") VALUES
('Conexión Postgres en Python', 'Conectar con psycopg2', $$import psycopg2
conn = psycopg2.connect("dbname=snippets_db user=snip_admin password=changeme123")
$$, 'public', now() - INTERVAL '30 days', 1, 1),
('Fetch API básico', 'Ejemplo fetch GET', $$fetch('/api/users').then(r => r.json()).then(console.log)$$, 'public', now() - INTERVAL '29 days', 2, 2),
('Copy array en JS', 'Clonar array sin mutar', $$const copy = [...arr];$$, 'public', now() - INTERVAL '28 days', 3, 2),
('Servidor Express mínimo', 'Express server', $$const express = require('express')
const app = express()
app.get('/', (req,res)=> res.send('ok'))
app.listen(3000)
$$, 'public', now() - INTERVAL '27 days', 4, 2),
('Consulta SQL paginada', 'LIMIT/OFFSET ejemplo', $$SELECT * FROM items ORDER BY id DESC LIMIT 20 OFFSET 0;$$, 'public', now() - INTERVAL '26 days', 5, 11),
('Regex email', 'Validar email simple', $$/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)$$, 'public', now() - INTERVAL '25 days', 6, 2),
('Dockerfile Node', 'Dockerfile básica', $$FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node","index.js"]
$$, 'public', now() - INTERVAL '24 days', 7, 18),
('Script backup Bash', 'Dump DB', $$#!/bin/bash
pg_dump -U $POSTGRES_USER $POSTGRES_DB > dump.sql
$$, 'private', now() - INTERVAL '23 days', 8, 12),
('Promise async/await', 'Ejemplo', $$async function fetchData() {
  const res = await fetch('/api')
  return res.json()
}$$, 'public', now() - INTERVAL '22 days', 9, 2),
('Clase singleton Java', 'Patrón singleton', $$public class Singleton {
  private static Singleton instance;
  private Singleton(){}
  public static Singleton getInstance(){
    if(instance == null) instance = new Singleton();
    return instance;
  }
}$$, 'public', now() - INTERVAL '21 days', 10, 4),
('Consulta with JOIN', 'Ejemplo JOIN', $$SELECT u.id, u.nombre, s.titulo FROM users u JOIN snippets s ON s.user_id = u.id;$$, 'public', now() - INTERVAL '20 days', 11, 11),
('Hook React simple', 'useState example', $$import React, {useState} from 'react'
function App(){ const [v,setV] = useState(0) }
$$, 'public', now() - INTERVAL '19 days', 12, 2),
('Comando curl POST', 'Enviar JSON', $$curl -X POST -H "Content-Type: application/json" -d '{"name":"x"}' http://localhost:3000/api$$, 'private', now() - INTERVAL '18 days', 13, 12),
('Query parametrizada', 'Evitar SQL injection', $$SELECT * FROM users WHERE email = $1;$$, 'public', now() - INTERVAL '17 days', 14, 11),
('Middleware auth', 'Express auth stub', $$function auth(req,res,next){ if(!req.user) return res.status(401).end(); next(); }$$, 'public', now() - INTERVAL '16 days', 15, 2),
('Hash password bcrypt', 'Ejemplo Node', $$const bcrypt = require('bcrypt');
const hash = await bcrypt.hash(password, 10);$$, 'public', now() - INTERVAL '15 days', 16, 2),
('K8s deployment', 'Deployment básico', $$apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 2
$$, 'private', now() - INTERVAL '14 days', 17, 19),
('GraphQL query', 'Query simple', $$query {
  user(id:1) { id name }
}$$, 'public', now() - INTERVAL '13 days', 18, 20),
-- ('Stored procedure SQL', 'Ejemplo simple', $$CREATE FUNCTION add(a int, b int) RETURNS int AS $$
-- BEGIN
--   RETURN a + b;
-- END;
-- $$ LANGUAGE plpgsql;$$, 'private', now() - INTERVAL '12 days', 19, 11),
('CSS grid simple', 'Grid layout', $$.container { display: grid; grid-template-columns: 1fr 2fr; }$$, 'private', now() - INTERVAL '11 days', 20, 15),
('HTML boilerplate', 'Estructura básica', $$<!doctype html><html><head><meta charset="utf-8"></head><body></body></html>$$, 'public', now() - INTERVAL '10 days', 21, 14),
('Lambda AWS (Python)', 'handler', $$def handler(event, context):
  return {'statusCode':200,'body':'ok'}$$, 'private', now() - INTERVAL '9 days', 22, 1),
('CLI Go ejemplo', 'Hello CLI', $$package main
import "fmt"
func main(){ fmt.Println("hello") }$$, 'private', now() - INTERVAL '8 days', 23, 6),
('Unit test Pytest', 'Ejemplo test', $$def test_sum():
  assert 1 + 1 == 2$$, 'private', now() - INTERVAL '7 days', 24, 1),
('Logging example', 'Uso de winston', $$const winston = require('winston');$$, 'private', now() - INTERVAL '6 days', 25, 2),
('Cron Linux', 'Crontab entry', $$0 2 * * * /usr/bin/backup.sh$$, 'private', now() - INTERVAL '5 days', 26, 12),
('Regex captura', 'Grupos', $$/(\d{4})-(\d{2})-(\d{2})/$$, 'private', now() - INTERVAL '4 days', 27, 2),
('Migrate SQL', 'Ejemplo ALTER', $$ALTER TABLE users ADD COLUMN phone VARCHAR(20);$$, 'private', now() - INTERVAL '3 days', 28, 11),
('Prisma schema', 'Modelo ejemplo', $$model User {
  id Int @id @default(autoincrement())
  email String @unique
}$$, 'public', now() - INTERVAL '2 days', 29, 29),
('Snippet ejemplo', 'Snippet genérico', $$console.log("hola mundo")$$, 'private', now() - INTERVAL '1 day', 30, 2);

COMMIT;

-- =========================
-- 30 comments
-- =========================

BEGIN TRANSACTION;

INSERT INTO "comments" ("user_id", "snippet_id", "content", "created_at") VALUES
(3, 1, 'Buen ejemplo, me sirvió para conectar rápido.', now() - INTERVAL '29 days'),
(4, 1, 'Cuidado con exponer la password en el código.', now() - INTERVAL '28 days'),
(5, 2, 'Faltó manejar errores en fetch.', now() - INTERVAL '27 days'),
(6, 3, 'Simple y claro.', now() - INTERVAL '26 days'),
(7, 4, 'Agregar CORS si es necesario.', now() - INTERVAL '25 days'),
(8, 5, '¿Funciona con más columnas?', now() - INTERVAL '24 days'),
(9, 6, 'Regex quedaron cortos para casos edge.', now() - INTERVAL '23 days'),
(10, 7, 'Perfecto para pruebas locales.', now() - INTERVAL '22 days'),
(11, 8, 'Recuerda dar permisos al script.', now() - INTERVAL '21 days'),
(12, 9, 'Usar try/catch para problemas de red.', now() - INTERVAL '20 days'),
(13, 10, 'Thread-safe? revisar singleton en multithread.', now() - INTERVAL '19 days'),
(14, 11, 'Query optimizable con índices.', now() - INTERVAL '18 days'),
(15, 12, 'Ejemplo de hook muy básico.', now() - INTERVAL '17 days'),
(16, 13, 'Recordar escapar comillas en JSON.', now() - INTERVAL '16 days'),
(17, 14, 'Muy importante usar parámetros.', now() - INTERVAL '15 days'),
(18, 15, 'Falta manejo de roles.', now() - INTERVAL '14 days'),
(19, 16, 'Bcrypt salt round recomendable 12.', now() - INTERVAL '13 days'),
(20, 17, 'Agregar readiness probe para K8s.', now() - INTERVAL '12 days'),
(21, 18, 'Query a GraphQL con variables.', now() - INTERVAL '11 days'),
-- (22, 19, 'Función útil para sumas pequeñas.', now() - INTERVAL '10 days'),
(23, 20, 'Grid se ve bien en mobile.', now() - INTERVAL '9 days'),
(24, 21, 'Agregar meta viewport para responsive.', now() - INTERVAL '8 days'),
(25, 22, 'Lambda tamaño del package importa.', now() - INTERVAL '7 days'),
(26, 23, 'Muy simple, ideal para ejemplo.', now() - INTERVAL '6 days'),
(27, 24, 'Test rápido y claro.', now() - INTERVAL '5 days'),
(28, 25, 'Winston es flexible para transports.', now() - INTERVAL '4 days'),
(29, 26, 'Programar el cron en UTC si conviene.', now() - INTERVAL '3 days'),
(30, 27, 'Regex captura OK.', now() - INTERVAL '2 days'),
(1, 28, 'IMPORTANTE: revisar migraciones en prod.', now() - INTERVAL '1 day'),
(2, 29, 'Prisma schema claro y directo.', now());

COMMIT;

-- =========================
-- 30 snippet_tags (one tag for one snippet; 1:1)
-- =========================

BEGIN TRANSACTION;

INSERT INTO "snippet_tags" ("snippet_id", "tag_id") VALUES
(1, 2),
(2, 4),
(3, 27),
(4, 4),
(5, 3),
(6, 5),
(7, 7),
(8, 22),
(9, 9),
(10, 14),
(11, 3),
(12, 11),
(13, 22),
(14, 3),
(15, 20),
(16, 10),
(17, 8),
(18, 18),
-- (19, 3),
(20, 25),
(21, 26),
(22, 1),
(23, 22),
(24, 9),
(25, 23),
(26, 17),
(27, 5),
(28, 3),
(29, 29),
(19, 30);

COMMIT;

-- =========================
-- 30 likes
-- Distributed for not repeat user+snippet
-- =========================

BEGIN TRANSACTION;

INSERT INTO "likes" ("user_id", "snippet_id", "created_at") VALUES
(2, 1, now() - INTERVAL '29 days'),
(3, 2, now() - INTERVAL '28 days'),
(4, 3, now() - INTERVAL '27 days'),
(5, 4, now() - INTERVAL '26 days'),
(6, 5, now() - INTERVAL '25 days'),
(7, 6, now() - INTERVAL '24 days'),
(8, 7, now() - INTERVAL '23 days'),
(9, 8, now() - INTERVAL '22 days'),
(10, 9, now() - INTERVAL '21 days'),
(11, 10, now() - INTERVAL '20 days'),
(12, 11, now() - INTERVAL '19 days'),
(13, 12, now() - INTERVAL '18 days'),
(14, 13, now() - INTERVAL '17 days'),
(15, 14, now() - INTERVAL '16 days'),
(16, 15, now() - INTERVAL '15 days'),
(17, 16, now() - INTERVAL '14 days'),
(18, 17, now() - INTERVAL '13 days'),
(19, 18, now() - INTERVAL '12 days'),
-- (20, 19, now() - INTERVAL '11 days'),
(21, 20, now() - INTERVAL '10 days'),
(22, 21, now() - INTERVAL '9 days'),
(23, 22, now() - INTERVAL '8 days'),
(24, 23, now() - INTERVAL '7 days'),
(25, 24, now() - INTERVAL '6 days'),
(26, 25, now() - INTERVAL '5 days'),
(27, 26, now() - INTERVAL '4 days'),
(28, 27, now() - INTERVAL '3 days'),
(29, 28, now() - INTERVAL '2 days'),
(30, 29, now() - INTERVAL '1 day'),
(1, 19, now());

COMMIT;

-- THERE YOU GO!!!