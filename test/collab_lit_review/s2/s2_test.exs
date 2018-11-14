defmodule CollabLitReview.S2Test do
  use CollabLitReview.DataCase

  alias CollabLitReview.S2

  describe "authors" do
    alias CollabLitReview.S2.Author

    @valid_attrs %{name: "some name", s2_id: 42}
    @update_attrs %{name: "some updated name", s2_id: 43}
    @invalid_attrs %{name: nil, s2_id: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> S2.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert S2.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert S2.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = S2.create_author(@valid_attrs)
      assert author.name == "some name"
      assert author.s2_id == 42
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = S2.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, %Author{} = author} = S2.update_author(author, @update_attrs)
      assert author.name == "some updated name"
      assert author.s2_id == 43
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = S2.update_author(author, @invalid_attrs)
      assert author == S2.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = S2.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> S2.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = S2.change_author(author)
    end
  end

  describe "papers" do
    alias CollabLitReview.S2.Paper

    @valid_attrs %{abstract: "some abstract", s2_id: 42, title: "some title"}
    @update_attrs %{abstract: "some updated abstract", s2_id: 43, title: "some updated title"}
    @invalid_attrs %{abstract: nil, s2_id: nil, title: nil}

    def paper_fixture(attrs \\ %{}) do
      {:ok, paper} =
        attrs
        |> Enum.into(@valid_attrs)
        |> S2.create_paper()

      paper
    end

    test "list_papers/0 returns all papers" do
      paper = paper_fixture()
      assert S2.list_papers() == [paper]
    end

    test "get_paper!/1 returns the paper with given id" do
      paper = paper_fixture()
      assert S2.get_paper!(paper.id) == paper
    end

    test "create_paper/1 with valid data creates a paper" do
      assert {:ok, %Paper{} = paper} = S2.create_paper(@valid_attrs)
      assert paper.abstract == "some abstract"
      assert paper.s2_id == 42
      assert paper.title == "some title"
    end

    test "create_paper/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = S2.create_paper(@invalid_attrs)
    end

    test "update_paper/2 with valid data updates the paper" do
      paper = paper_fixture()
      assert {:ok, %Paper{} = paper} = S2.update_paper(paper, @update_attrs)
      assert paper.abstract == "some updated abstract"
      assert paper.s2_id == 43
      assert paper.title == "some updated title"
    end

    test "update_paper/2 with invalid data returns error changeset" do
      paper = paper_fixture()
      assert {:error, %Ecto.Changeset{}} = S2.update_paper(paper, @invalid_attrs)
      assert paper == S2.get_paper!(paper.id)
    end

    test "delete_paper/1 deletes the paper" do
      paper = paper_fixture()
      assert {:ok, %Paper{}} = S2.delete_paper(paper)
      assert_raise Ecto.NoResultsError, fn -> S2.get_paper!(paper.id) end
    end

    test "change_paper/1 returns a paper changeset" do
      paper = paper_fixture()
      assert %Ecto.Changeset{} = S2.change_paper(paper)
    end
  end
end
