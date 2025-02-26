defmodule CommunityGardenTest do
  use ExUnit.Case

  @task_id 1
  test "start returns an alive pid" do
    assert {:ok, pid} = CommunityGarden.start()
    assert Process.alive?(pid)
  end

  @task_id 2
  test "when started, the registry is empty" do
    assert {:ok, pid} = CommunityGarden.start()
    assert [] == CommunityGarden.list_registrations(pid)
  end

  @task_id 3
  test "can register a new plot" do
    assert {:ok, pid} = CommunityGarden.start()
    assert %Plot{} = CommunityGarden.register(pid, "Johnny Appleseed")
  end

  @task_id 3
  test "maintains a registry of plots" do
    assert {:ok, pid} = CommunityGarden.start()
    assert %Plot{} = plot = CommunityGarden.register(pid, "Johnny Appleseed")
    assert [plot] == CommunityGarden.list_registrations(pid)
  end

  @task_id 4
  test "can release a plot" do
    assert {:ok, pid} = CommunityGarden.start()
    assert %Plot{} = plot = CommunityGarden.register(pid, "Johnny Appleseed")
    assert :ok = CommunityGarden.release(pid, plot.plot_id)
    assert [] == CommunityGarden.list_registrations(pid)
  end

  @task_id 5
  test "can get registration of a registered plot" do
    assert {:ok, pid} = CommunityGarden.start()
    assert %Plot{} = plot = CommunityGarden.register(pid, "Johnny Appleseed")
    assert %Plot{} = registered_plot = CommunityGarden.get_registration(pid, plot.plot_id)
    assert registered_plot.plot_id == plot.plot_id
    assert registered_plot.registered_to == "Johnny Appleseed"
  end

  @task_id 5
  test "return not_found when attempt to get registration of an unregistered plot" do
    assert {:ok, pid} = CommunityGarden.start()
    assert {:not_found, "plot is unregistered"} = CommunityGarden.get_registration(pid, 1)
  end
end
