$(function() {
  $("#content").ready(function() {
    if (window.location.pathname == "/contribute/docs/"){
      $("div.contribute").hide();

      if (window.location.hash) {
        $(".edit-code").show();
        $(".browse-code").hide();

        var url = $(this).find(".edit-btn").attr("href")
        var hash = window.location.hash.split('#')[1]
        hash = decodeURIComponent(hash)

        $(this).find(".edit-btn").attr("href", url + "/edit/master/content/" + hash);
        $(this).find(".show-btn").attr("href", url + "/blob/master/content/" + hash);

        var edit_html = $(this).find(".edit-btn").html()
        var show_html = $(this).find(".show-btn").html()

        $(this).find(".edit-btn").html(edit_html + "content/" + hash)
        $(this).find(".show-btn").html(show_html + "content/" + hash)
      }
    }
  });
});
