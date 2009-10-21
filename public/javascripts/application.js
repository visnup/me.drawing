var Me = { };

Me.Draw = function() {
  var _ = { };

  var save = function() {
    $.post('/drawings', {
      'points[]': _.points
    });
  };

  var load = function() {
    $.getJSON('/drawings', function(drawings) {
      var ctx = _.canvas.get(0).getContext('2d');
      for (var d in drawings) {
        d = drawings[d];
        ctx.beginPath();
        ctx.moveTo.apply(ctx, d.points.shift());
        for (var p in d.points) {
          ctx.lineTo.apply(ctx, d.points[p]);
        }
        ctx.stroke();
      }
    });
  };

  $(document).ready(function() {
    var w = $(document.body);
    _.canvas = $('<canvas>')
      .attr('width', w.width()).attr('height', w.height())
      .appendTo(w);
    load();

    $('form').submit(function() {
      $.post('/posts', $(this).serialize());
      return false;
    });
  });

  $(document).mousedown(function(e) {
    console.log(e.target);
    var ctx = _.ctx = _.canvas.get(0).getContext('2d');
    ctx.beginPath();
    ctx.moveTo(e.pageX, e.pageY);
    _.points = [ [e.pageX, e.pageY] ];
  })

  $(document).mousemove(function(e) {
    var ctx = _.ctx;
    if (ctx) {
      ctx.lineTo(e.pageX, e.pageY);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(e.pageX, e.pageY);
      _.points.push([e.pageX, e.pageY]);
    }
    return false;
  });

  $(document).mouseup(function() {
    _.ctx = null;
    save();
  });
};

var me = new Me.Draw();
