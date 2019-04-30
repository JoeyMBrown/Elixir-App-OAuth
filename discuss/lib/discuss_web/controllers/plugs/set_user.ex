defmodule Discuss.Plugs.SetUser do
    import Plug.Conn #lots of helper functions for working with conn object, assign comes from here
    import Phoenix.Controller#session comes from here

    alias Discuss.Repo
    alias Discuss.User

    def init(_params) do
    end

    #params is what is returned from init function
    def call(conn, _params) do
        user_id = get_session(conn, :user_id)

        cond do
            #statement behind && is what gets returned. So return value is assigned to user = While checking for truthy value.
            #Assign, places :user, user key pair in assigns part of conn. Allows any FOLLOWING plug to acsess the user struct we placed there!
            user = user_id && Repo.get(User, user_id) ->
                assign(conn, :user, user)
            #Catch-all statement incase there is no user.
            #Used to assign :user to nil, to allow us to tell there is no user signed in.
            true ->
                assign(conn, :user, nil)
        end

    end
end