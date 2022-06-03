
def call(Map config = [:]) {
  def scriptContents = libraryResource "/io/netspace/remote-save-docker-img.sh"
  writeFile file: "${config.name}", text: scriptContents
  sh "chmod a+x ./${config.name}"
}
