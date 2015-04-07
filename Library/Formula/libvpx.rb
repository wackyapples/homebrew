require 'formula'

class Libvpx < Formula
  homepage 'http://www.webmproject.org/code/'
  url "https://github.com/webmproject/libvpx/archive/v1.4.0.tar.gz"
  sha256 "eca30ea7fae954286c9fe9de9d377128f36b56ea6b8691427783b20c67bcfc13"

  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    revision 1
    sha1 "9ce8fe3ae1d8fa737bc3d900b289da0838c2500a" => :yosemite
    sha1 "65a8b42abf0c83ed0e9faec7791150b68836f862" => :mavericks
  end

  depends_on 'yasm' => :build

  option 'gcov', 'Enable code coverage'
  option 'mem-tracker', 'Enable tracking memory usage'
  option 'visualizer', 'Enable post processing visualizer'
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  def install
    args = ["--prefix=#{prefix}", "--enable-pic", "--disable-unit-tests"]
    args << (build.with?("examples") ? "--enable-examples" : "--disable-examples")
    args << "--enable-gcov" if build.include? "gcov" and not ENV.compiler == :clang
    args << "--enable-mem-tracker" if build.include? "mem-tracker"
    args << "--enable-postproc-visualizer" if build.include? "visualizer"

    # configure misdetects 32-bit 10.6
    # http://code.google.com/p/webm/issues/detail?id=401
    if MacOS.version == "10.6" && Hardware.is_32_bit?
      args << "--target=x86-darwin10-gcc"
    end

    mkdir 'macbuild' do
      system "../configure", *args
      system "make install"
    end
  end
end
