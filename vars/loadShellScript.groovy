
def call(Map config = [:]) {
  echo "Writing script..."
  def scriptContents = libraryResource "${config.name}"
  writeFile file: "${config.name}", text: scriptContents
  sh "chmod a+x ./${config.name}"
}
