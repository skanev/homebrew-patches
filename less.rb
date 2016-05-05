# This is a patched less that allows to bind keys to shell commands without
# having to wait (and see "!done") when they have finished. This is vaguely
# useful if you want to turn less into a more powerful interface via lesskey,
# but you don't want it to to suck.
class Less < Formula
  desc "Pager program similar to more (with a small patch)"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "http://www.greenwoodsoftware.com/less/less-481.tar.gz"
  sha256 "3fa38f2cf5e9e040bb44fffaa6c76a84506e379e47f5a04686ab78102090dda5"

  depends_on "pcre" => :optional

  patch :DATA

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-regex=pcre" if build.with? "pcre"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
__END__
diff --git a/command.c b/command.c
index c31fa81..0cc5a22 100644
--- a/command.c
+++ b/command.c
@@ -273,10 +273,13 @@ exec_mca()
 
 		if (secure)
 			break;
-		if (shellcmd == NULL)
+		if (shellcmd == NULL) {
 			lsystem("", "!done");
-		else
+		} else if (getenv("LESS_QUICKSHELL") != NULL) {
+			lsystem(shellcmd, (char *) NULL);
+		} else {
 			lsystem(shellcmd, "!done");
+		}
 		break;
 #endif
 #if PIPEC
