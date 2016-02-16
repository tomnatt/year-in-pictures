$(function() {
  $(document).foundation();
  $("a.right-off-canvas-toggle").on("click", function() {
  });
});

$(function() {
  $(".month-navigation ul li a").click(function() {
    var target = $(this).attr('href');
    $("html,body").animate({
      scrollTop: $(target).offset().top
    },"1000");
  })
})
