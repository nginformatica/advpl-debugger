/**
 * Folding da árvore sintática gerada.
 * @author Marcelo Camargo
 */
(function(syntax) {

  // Aplicar folding nos elementos definidos como foldables pelo parser
  var folders = syntax.getElementsByClassName("folder");

  for (var i = 0, len = folders.length; i < len; i++) {
    folders[i].appendChild((function() {
      var image = document.createElement("img");
      image.src = "fold_minus.png";
      return image;
    })());

    folders[i].onclick = function(e) {
      if (this.nextSibling.style.display === "none") {
        this.nextSibling.style.display = "inline";
        this.firstChild.src = "fold_minus.png";
      } else {
        this.nextSibling.style.display = "none";
        this.firstChild.src = "fold_plus.png";
      }
    };
  }
})(window.document);