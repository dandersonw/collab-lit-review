# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CollabLitReview.Repo.insert!(%CollabLitReview.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CollabLitReview.Repo
alias CollabLitReview.Users.User
# alias CollabLitReview.Tasks.Task

pwhash = Argon2.hash_pwd_salt("pword")

Repo.insert!(%User{email: "foo", password_hash: pwhash})
Repo.insert!(%User{email: "bar", password_hash: pwhash})
