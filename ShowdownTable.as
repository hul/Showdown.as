package
{
    import mx.utils.StringUtil;

    public class ShowdownTable
    {
        public function ShowdownTable()
        {
            
        }
        
        private var converter = Showdown;
        private var style = 'text-align:left;'
        
        private function th(header)
        {
            if (StringUtil.trim(header) === "") { return "";}
            var id = StringUtil.trim(header).replace(/ /g, '_').toLowerCase();
            return '<th id="' + id + '" style="'+style+'">' + header + '</th>';
        }
        
        private function td(cell) 
        {
            return '<td style="'+style+'">' + converter.makeHtml(cell) + '</td>';
        };
        
        private function ths(hs) 
        {
            var out = "", i = 0;
            for (i;i<hs.length;i+=1) {
                out += th(hs[i]) + '\n';
            }
            return out;
        }
        
        private function tds(ds)
        {
            var out = "", i = 0;
            for (i;i<ds.length;i+=1) {
                out += td(ds[i]) + '\n';
            }
            return out;
        }
        
        private function thead(hs)
        {
            var out, i = 0;
            out = "<thead>\n";
            out += "<tr>\n";
            out += ths(hs);
            out += "</tr>\n";
            out += "</thead>\n";
            return out;
        }
        
        private function tr(cs) 
        {
            var out, i = 0;
            out = "<tr>\n";
            out += tds(cs);
            out += "</tr>\n";
            return out;
        }
        
        public function filter(text) 
        {
            var i=0;
            var lines = text.split('\n');
            var line, hs, rows, out = [];
            for (i; i<lines.length;i+=1) {
                line = lines[i];
                // looks like a table heading
                if (StringUtil.trim(line).match(/^[|]{1}.*[|]{1}$/)) {
                    line = StringUtil.trim(line);
                    var tbl = [];
                    tbl.push('<table>');
                    hs = line.substring(1, line.length -1).split('|');
                    trace (hs, typeof(hs));
                    tbl.push(thead(hs));
                    line = lines[++i];
                    if (!StringUtil.trim(line).match(/^[|]{1}[-=|: ]+[|]{1}$/)) {
                        // not a table rolling back
                        line = lines[--i];
                    }
                    else {
                        line = lines[++i];
                        tbl.push('<tbody>');
                        while (StringUtil.trim(line).match(/^[|]{1}.*[|]{1}$/)) {
                            line = StringUtil.trim(line);
                            tbl.push(tr(line.substring(1, line.length -1).split('|')));
                            line = lines[++i];
                        }
                        tbl.push('</tbody>');
                        tbl.push('</table>');
                        // we are done with this table and we move along
                        out.push(tbl.join('\n'));
                        continue;
                    }
                }
                trace ('out.push(', line, ')');
                out.push(line);
            }
            return out.join('\n');
        }
        
    }
}