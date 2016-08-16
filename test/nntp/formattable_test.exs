defmodule Athel.Nntp.FormatTest do
  use ExUnit.Case, async: true

  alias Athel.Nntp.Formattable
  alias Athel.Article
  alias Athel.Group

  test "multiline multiline" do
    assert Formattable.format(~w(cat in the hat)) == "cat\r\nin\r\nthe\r\nhat\r\n.\r\n"
  end

  test "singleline multiline" do
    assert Formattable.format(~w(HORSE)) == "HORSE\r\n.\r\n"
  end

  test "empty multiline" do
    assert Formattable.format([]) == ".\r\n"
  end

  test "multiline with non-binary lines" do
    assert Formattable.format(1..5) == "1\r\n2\r\n3\r\n4\r\n5\r\n.\r\n"
  end

  test "article" do
    article = create_article()
    assert Formattable.format(article) == "Content-Type: text/plain\r\nDate: Wed, 04 May 2016 03:02:01 -0500\r\nFrom: Me\r\nMessage-ID: <123@test.com>\r\nNewsgroups: fun.times,blow.away\r\nReferences: <547@heav.en>\r\nSubject: Talking to myself\r\n\r\nhow was your day?\r\nyou're too kind to ask\r\n.\r\n"
  end

  test "article without optional fields" do
    article = %{create_article() | parent_message_id: nil, from: nil, date: nil}
    assert Formattable.format(article) == "Content-Type: text/plain\r\nMessage-ID: <123@test.com>\r\nNewsgroups: fun.times,blow.away\r\nSubject: Talking to myself\r\n\r\nhow was your day?\r\nyou're too kind to ask\r\n.\r\n"
  end

  defp create_article do
    groups = [
      %Group {
        name: "fun.times",
        status: "y",
        low_watermark: 0,
        high_watermark: 0
      },
      %Group {
        name: "blow.away",
        status: "m",
        low_watermark: 0,
        high_watermark: 0
      }
    ]
    %Article {
      message_id: "123@test.com",
      from: "Me",
      subject: "Talking to myself",
      date: Timex.to_datetime({{2016, 5, 4}, {3, 2, 1}}, "America/Chicago"),
      parent_message_id: "547@heav.en",
      content_type: "text/plain",
      groups: groups,
      body: ["how was your day?", "you're too kind to ask"]
    }
  end
end
