#!/bin/sh

# Apply the migrations that are committed to git.
# (We no longer run makemigrations here: new migrations should be created
# during development, reviewed, and committed, not generated at startup.)
echo "Migrating the database."
python manage.py migrate --noinput

exec "$@"
