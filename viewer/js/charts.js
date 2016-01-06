$(function () {
    Highcharts.setOptions({
        chart: {
            style: {
                fontFamily: 'Muli'
            }
        }
    });
    
    $('#percentimpressions').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false
        },
        colors: ['#0A5F0D','#5F0D0A'],
        title: {
            text: '% of Impressions In/Outside Any Geofences',
            align: 'center',
            y: 60
        },
        tooltip: {
            pointFormat: '<b>{point.percentage:.2f}%</b> impressions'
        },
        plotOptions: {
            pie: {
                size: '300px',
                dataLabels: {
                    enabled: true,
                    distance: 15,
                    style: {
                        color: 'black',
                    }
                },
                startAngle: -90,
                endAngle: 90,
                center: ['50%', '75%']
            }
        },
        series: [{
            type: 'pie',
            name: '% of Impressions',
            innerSize: '50%',
            data: [
                ['Inside', 10.32],
                ['Outside', 89.68]
            ]
        }]
    });
    
    $('#percentfences').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false
        },
        colors: ['#0A5F0D','#5F0D0A'],
        title: {
            text: '% of Geofences w/ Any Impressions',
            align: 'center',
            y: 60
        },
        tooltip: {
            pointFormat: '<b>{point.percentage:.2f}% geofences</b>'
        },
        plotOptions: {
            pie: {
                size: '300px',
                dataLabels: {
                    enabled: true,
                    distance: 15,
                    style: {
                        color: 'black',
                    }
                },
                startAngle: -90,
                endAngle: 90,
                center: ['50%', '75%']
            }
        },
        series: [{
            type: 'pie',
            name: '% of Impressions',
            innerSize: '50%',
            data: [
                ['w/ Impressions', 97.04],
                ['w/out Impressions', 2.96]
            ]
        }]
    });
    
    /**
    * Extend the Axis.getLinePath method in order to visualize breaks with two parallel
    * slanted lines. For each break, the slanted lines are inserted into the line path.
    */
    Highcharts.wrap(Highcharts.Axis.prototype, 'getLinePath', function (proceed, lineWidth) {
        var axis = this,
            path = proceed.call(this, lineWidth),
            x = path[1],
            y = path[2];

        Highcharts.each(this.breakArray || [], function (brk) {
            if (axis.horiz) {
                x = axis.toPixels(brk.from);
                path.splice(3, 0,
                    'L', x - 4, y, // stop
                    'M', x - 9, y + 5, 'L', x + 1, y - 5, // left slanted line
                    'M', x - 1, y + 5, 'L', x + 9, y - 5, // higher slanted line
                    'M', x + 4, y
                );
            } else {
                y = axis.toPixels(brk.from);
                path.splice(3, 0,
                    'L', x, y - 4, // stop
                    'M', x + 5, y - 9, 'L', x - 5, y + 1, // lower slanted line
                    'M', x + 5, y - 1, 'L', x - 5, y + 9, // higher slanted line
                    'M', x, y + 4
                );
            }
        });
        return path;
    });

    /**
     * On top of each column, draw a zigzag line where the axis break is.
     */
    function pointBreakColumn(e) {
        var point = e.point,
            brk = e.brk,
            shapeArgs = point.shapeArgs,
            x = shapeArgs.x,
            y = this.translate(brk.from, 0, 1, 0, 1),
            w = shapeArgs.width,
            key = ['brk', brk.from, brk.to],
            path = ['M', x, y, 'L', x + w * 0.25, y + 4, 'L', x + w * 0.75, y - 4, 'L', x + w, y];

        if (!point[key]) {
            point[key] = this.chart.renderer.path(path)
                .attr({
                    'stroke-width': 2,
                    stroke: point.series.options.borderColor
                })
                .add(point.graphic.parentGroup);
        } else {
            point[key].attr({
                d: path
            });
        }
    }
    
    $('#barimpressions').highcharts({
        chart: {
            type: 'column'
        },
        colors: ['#0D0A5F'],
        title: {
            text: 'Number of Impressions w/ a Geofence Match',
            align: 'center'
        },
        xAxis: {
            categories: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29'],
            title: {
                text: '# matched geofences'
            }
        },
        yAxis: {
            lineWidth: 1,
            title: false,
            max: 2325000,
            tickInterval: 5000,
            breaks: [{
                from: 85000,
                to: 2300000
            }],
            events: {
                pointBreak: pointBreakColumn
            }
        },
        tooltip: {
            headerFormat: '<b>{point.y:.f} impressions</b><br>',
            pointFormat: 'matched {point.category} geofences'
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0
            }
        },
        series: [{
            name: '# impressions',
            data: [2323873, 6227, 56567, 6565, 27022, 16874, 1163, 12175, 97, 80657, 1761, 14076, 9992, 2019, 1064, 320, 691, 4, 5687, 552, 22043, 81, 843, 163, 189, 307, 109, 11, 0, 43]
        }]
    });
});

