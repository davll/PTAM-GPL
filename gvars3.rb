require "formula"

class Gvars3 < Formula
  homepage "https://github.com/edrosten/gvars"
  url "https://github.com/edrosten/gvars.git", :using => :git
  version 'master'

  depends_on "automake" => :build
  depends_on "readline"
  depends_on "toon" => :recommended

  def install
    ENV["CPPFLAGS"] = "-I#{Formula["readline"].include}"
    ENV["CXXFLAGS"] = "-stdlib=libstdc++"
    ENV["LDFLAGS"] = "-stdlib=libstdc++ -L#{Formula["readline"].lib}"

    args = %w(--disable-widgets
              --without-debug)
    args << "--with-TooN=#{(build.with?('toon') ? 'yes' : 'no')}"
    args << "--prefix=#{prefix}"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
