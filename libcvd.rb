require "formula"

class Libcvd < Formula
  homepage "https://github.com/edrosten/libcvd"
  url "https://github.com/edrosten/libcvd.git", :using => :git
  version 'master'

  depends_on "automake" => :build
  depends_on :libpng => ['universal']
  depends_on 'jpeg' => ['universal']
  depends_on 'toon' => :recommended
  depends_on 'ffmpeg' => :optional
  depends_on :x11

  patch do
    url "https://github.com/edrosten/libcvd/pull/8.patch"
    sha1 "f95f00f6b150ee8da9bb9d6c5a9bbdc9d8488543"
  end

  def install
    #sdk_path = File.join(`xcode-select -p`.strip,
    #                         'Platforms/MacOSX.platform/Developer/SDKs',
    #                         'MacOSX10.8.sdk')
    #arch = '-arch i386'
    #sdk = "-isysroot #{sdk_path}"
    #sdklib = "-Wl,-syslibroot,#{sdk_path}"
    #ENV["MACOSX_DEPLOYMENT_TARGET"] = '10.5'
    #ENV["CFLAGS"] = "#{arch} #{sdk} -mmacosx-version-min=10.5 -m32 -D_OSX"
    #ENV["CXXFLAGS"] = ENV["CFLAGS"]
    #ENV["CPPFLAGS"] = ENV["CFLAGS"]
    #ENV["LDFLAGS"] = "#{arch} #{sdklib} -mmacosx-version-min=10.5 -m32"

    ENV["CXXFLAGS"] = "-stdlib=libstdc++"
    ENV["LDFLAGS"] = "-stdlib=libstdc++"

    args = %w(--disable-debug
              --with-sse --with-sse2
              --with-pthread
              --with-jpeg --without-tiff --with-png
              --with-lapack)
    args << "--with-toon=#{(build.with?('toon') ? 'yes' : 'no')}"
    args << "--with-ffmpeg=#{(build.with?('ffmpeg') ? 'yes' : 'no')}"
    args << "--with-x"
    args << "--without-qtbuffer"
    args << "--prefix=#{prefix}"

    inreplace "progs/video_play_source.cc",
              Regexp.new(Regexp.escape("glTexImage2D(*frame, 0, GL_TEXTURE_RECTANGLE_NV);")),
              "glTexImage2D(*frame, 0, texTarget);"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "make test"
  end
end
