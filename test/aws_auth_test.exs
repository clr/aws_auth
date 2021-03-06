defmodule AWSAuthTest do
  use ExUnit.Case

  test "url signing" do
    signed_request = AWSAuth.sign_url("AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
      "GET", 
      "https://examplebucket.s3.amazonaws.com/test.txt", 
      "us-east-1", 
      "s3",
      HashDict.new,
      Timex.Date.from({2013,05,24}, Timex.Date.timezone("GMT")))

    assert signed_request == "https://examplebucket.s3.amazonaws.com/test.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIOSFODNN7EXAMPLE%2F20130524%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20130524T000000Z&X-Amz-Expires=86400&X-Amz-Signature=aeeed9bbccd4d02ee5c0109b86d86835f995330da4c265957d157751f604d404&X-Amz-SignedHeaders=host"
  end

  test "sign_authorization_header" do
    headers = HashDict.new
    |> Dict.put("Range", "bytes=0-9")
    |> Dict.put("x-amz-date", "20130524T000000Z")

    signed_request = AWSAuth.sign_authorization_header("AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
      "GET", 
      "https://examplebucket.s3.amazonaws.com/test.txt", 
      "us-east-1", 
      "s3",
      headers,
      "",
      Timex.Date.from({2013,05,24}, Timex.Date.timezone("GMT")))

    assert signed_request == "AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/s3/aws4_request,SignedHeaders=host;range;x-amz-content-sha256;x-amz-date,Signature=f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41"
  end

  test "sign_authorization_header PUT" do
    headers = HashDict.new
    |> Dict.put("Date", "Fri, 24 May 2013 00:00:00 GMT")
    |> Dict.put("x-amz-storage-class", "REDUCED_REDUNDANCY")
    |> Dict.put("x-amz-date", "20130524T000000Z")

    signed_request = AWSAuth.sign_authorization_header("AKIAIOSFODNN7EXAMPLE", "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
      "PUT", 
      "https://examplebucket.s3.amazonaws.com/test$file.text", 
      "us-east-1", 
      "s3",
      headers,
      "Welcome to Amazon S3.",
      Timex.Date.from({2013,05,24}, Timex.Date.timezone("GMT")))

    assert signed_request == "AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/s3/aws4_request,SignedHeaders=date;host;x-amz-content-sha256;x-amz-date;x-amz-storage-class,Signature=98ad721746da40c64f1a55b78f14c238d841ea1380cd77a1b5971af0ece108bd"
  end
end
