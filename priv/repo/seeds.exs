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
alias CollabLitReview.S2
alias CollabLitReview.Reviews.Review
alias CollabLitReview.Reviews

pwhash = Argon2.hash_pwd_salt("pword")

foo = Repo.insert!(%User{email: "foo", password_hash: pwhash})
bar = Repo.insert!(%User{email: "bar", password_hash: pwhash})

author = S2.get_or_fetch_author(1741101)
paper = S2.get_or_fetch_paper("bcfdf6d906f4c5214ff25f1c71ec6ffb18a791e0")

review = Repo.insert!(%Review{title: "Foo Bar"})

Reviews.add_collaborator_to_review(foo, review)
Reviews.add_collaborator_to_review(bar, review)

Reviews.create_discovery(review, paper: paper)
