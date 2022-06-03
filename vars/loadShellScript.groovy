
def call(Map config = [:]) {
  echo "Writing script..."
  def scriptContents = libraryResource "/io/netspace/${config.name}"
  writeFile file: "${config.name}", text: scriptContents
  sh "chmod a+x ./${config.name}"
}
