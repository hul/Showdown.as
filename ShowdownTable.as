package
{
    public class ShowdownTable
    {
        public function ShowdownTable()
        {
            
        }
        
        private static var converter = Showdown;
        private static var style = 'text-align:left;'
        
        private static function th(header)
        {
            if (header.trim() === "") { return "";}
            var id = header.trim().replace(/ /g, '_').toLowerCase();
            return '<th id="' + id + '" style="'+style+'">' + header + '</th>';
        }
        
        private static function td(cell) 
        {
            return '<td style="'+style+'">' + converter.makeHtml(cell) + '</td>';
        };
        
        private static function ths 
        {
            var out = "", i = 0, hs = [].slice.apply(arguments);
            for (i;i<hs.length;i+=1) 
            {
                out += th(hs[i]) + '\n';
            }
            return out;
        }
        
        private static function tds 
        {
            var out = "", i = 0, ds = [].slice.apply(arguments);
            for (i;i<ds.length;i+=1) 
            {
                out += td(ds[i]) + '\n';
            }
            return out;
        }
        
        private static function thead 
        {
            var out, i = 0, hs = [].slice.apply(arguments);
            out = "<thead>\n";
            out += "<tr>\n";
            out += ths.apply(this, hs);
            out += "</tr>\n";
            out += "</thead>\n";
            return out;
        }
        
        private static function tr() 
        {
            var out, i = 0, cs = [].slice.apply(arguments);
            out = "<tr>\n";
            out += tds.apply(this, cs);
            out += "</tr>\n";
            return out;
        }
        
        public static function filter(text) 
        {
            var i=0, lines = text.split('\n'), line, hs, rows, out = [];
            for (i; i<lines.length;i+=1) {
                line = lines[i];
                // looks like a table heading
                if (line.trim().match(/^[|]{1}.*[|]{1}$/)) {
                    line = line.trim();
                    var tbl = [];
                    tbl.push('<table>');
                    hs = line.substring(1, line.length -1).split('|');
                    tbl.push(thead.apply(this, hs));
                    line = lines[++i];
                    if (!line.trim().match(/^[|]{1}[-=|: ]+[|]{1}$/)) {
                        // not a table rolling back
                        line = lines[--i];
                    }
                    else {
                        line = lines[++i];
                        tbl.push('<tbody>');
                        while (line.trim().match(/^[|]{1}.*[|]{1}$/)) {
                            line = line.trim();
                            tbl.push(tr.apply(this, line.substring(1, line.length -1).split('|')));
                            line = lines[++i];
                        }
                        tbl.push('</tbody>');
                        tbl.push('</table>');
                        // we are done with this table and we move along
                        out.push(tbl.join('\n'));
                        continue;
                    }
                }
                out.push(line);
            }
            return out.join('\n');
        };
        
    }
}