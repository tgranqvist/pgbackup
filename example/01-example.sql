CREATE TABLE "testing" (
  "id" serial NOT NULL,
  "foo" boolean NOT NULL,
  "bar" character(15) NOT NULL,

  PRIMARY KEY ("id")
);

INSERT INTO testing (foo, bar) VALUES (true, 'alpha');
INSERT INTO testing (foo, bar) VALUES (true, 'bravo');
INSERT INTO testing (foo, bar) VALUES (false, 'charlie');