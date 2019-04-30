defmodule DiscussWeb.TopicController do
    use DiscussWeb, :controller

    alias Discuss.Topic
    alias Discuss.Repo

    #Render line: Render index.html with a key of topics: that has a value of the var topics
    def index(conn, _params) do
        topics = Repo.all(Topic)
        render conn, "index.html", topics: topics
    end

    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})

        render(conn, "new.html", changeset: changeset)
    end

    #Changeset creates a new empty topic struct, and passes in the topic var.
    #Repo.insert trys to insert the new record into the database.
    def create(conn, %{"topic" => topic} = params) do
        changeset = Topic.changeset(%Topic{}, topic)

    #topic_path: I'm sending the user (conn) to the index function in the topic controller.
        case Repo.insert(changeset) do
            {:ok, _topic} -> 
                conn
                |> put_flash(:info, "Topic Created")
                |> redirect(to: Routes.topic_path(conn, :index))
            {:error, changeset} -> 
                render conn, "new.html", changeset: changeset

                #put_flash(conn, :error, "Invalid Topic Name")
        end
    end

    #key is "id" because of route specified in the router.ex
    #Repo.get find a single record in our Topic db, with the topic_id
    def edit(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
    end

    #Get old topic, create a changeset using old_topic, and new topic as what you want to change
    #First argument in the changeset is the struct in the database, second is new attributes you want to update
    #New obj is returned telling database how you want to update the old topic.

    #Repo.update pulls id out so it knows which to update.
    def update(conn, %{"id" => topic_id, "topic" => topic}) do
        old_topic = Repo.get(Topic, topic_id)
        changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)

        case Repo.update(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic Updated")
                |> redirect(to: Routes.topic_path(conn, :index))
            {:error, changeset} -> 
                render conn, "edit.html", changeset: changeset, topic: old_topic
        end
    end

    def delete(conn, %{"id" => topic_id}) do
        Repo.get!(Topic, topic_id) |> Repo.delete!

        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: Routes.topic_path(conn, :index))
    end

end