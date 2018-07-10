
<%@page import="java.util.Calendar"%>
<%@page import="redes.Rede"%>
<!DOCTYPE HTML>

<HTML>

    <HEAD>

        <TITLE>
            Tabela de IPv4
        </TITLE>
        
        <meta charset="UTF-8"/>

        <style>
                table, th, td {
                    border: 1px solid black;
                    border-collapse: collapse;
                    font-family: Consolas;
                }
        </style>

    </HEAD>

    <BODY>

        <table>

            <tr style="color: green">
                <th>CIDR</th>
                <th>Quantidade de Bit=0</th>
                <th>Quantidade de IPs</th>
                <th>M�scara (Decimal)</th>
                <th>M�scara (Bin�rio)</th>
                <th>Quantidade de Host</th>
            </tr>

            <script>
                
                var c = 0;

                var mask = 32;
                var ip = 1;
                var host = 1;

                for(var bit = 0; bit <= 32; bit++) {

                    mask = 32 - bit;
                    ip = Math.pow(2, bit);
                    host = Math.abs(ip - 2);

                    document.write("<tr" + ((bit%2==0)?(' style="color: ' + ((bit%8==0)?('red'):('blue')) + '"'):('')) + ">")
                    
                    document.write("<th>/" + mask + "</th>")

                    document.write("<th> 32 - "+ mask +" = "+bit+"</th>")

                    document.write("<th> 2^"+bit+" = "+ ip +"</th>")

                    var str = "";
                    var b = bit
                    for(c=0; c<4; c++) {
                        var d = b;
                        if(d>8) {
                            d = 8;
                        } else if(d<0) {
                            d = 0;
                        }
                        b = b - 8;
                        str = (256 - Math.pow(2, d)) + ((c==0)?(""):(".")) + str
                    }
                    document.write("<th>" + str + "</th>")

                    document.write("<th>")
                    for(c=0; c<32; c++) {
                        if(c<mask) {
                            document.write('1')
                        } else {
                            document.write('0')
                        }
                        if(c%8==7 && c<31) {
                            document.write('.')
                        }
                    }
                    document.write("</th>")

                    document.write("<th>"+ host +"</th>")

                    document.write("</tr>")
                }

            </script>

        </table>
        
        <h3>
            Como se representa uma rede:
        </h3>
        <h4>
            O IPv4 s�o os 4
            n�meros decimais inteiros n�o-negativos
            (entre 0 e 255)
            /* OCTETOS */
            separados por <i>PONTO</i>
            <br>
            e ent�o uma <i>BARRA</i>
            (/)
            separando o IP da M�scara de Rede,
            (um �ltimo n�mero decimal inteiro n�o-negativo entre 0 e 32).
        </h4>
        <H2 style="color: red;">
            Evite divis�es muito grandes, os c�lculos passam a demorar muito.
        </H2>
        
        <form name="Networds" action="index.jsp#Sub-rede" method="POST" style="font-family: Consolas;">
            
            REDE: <input type="text" name="Network" value="255.255.255.0/24" />
                <br>
            
            divisor = <input type="text" name="Division" value=1 />
                <br>
                
            <input type="submit" value="Sub-dividir rede" name="BigFriendlyButton" />
                <br>
                
        </form>
        
        <a name="Sub-rede">
            <h2>
                Divis�o de subrede:
            </h2>
        </a>
        
        <%
            String rede = request.getParameter("Network");
            long div = 0;
            
            try {
                div = Long.parseLong(request.getParameter("Division"));
                
                if(div<1)   //  Divisor Inv�lido
                    out.println("<script>alert('Entrada de divisor (" + div + ") inv�lida');</script>");
                
                else {  //  Divisor OK
                    
                    int[] oct = {0, 0, 0, 0};
                    int mask = 24;
                    String[] ip = rede.split("/");
                    rede = "";
                    
                    try {
                        
                        int c = 0;  //  Utilizado mais para frente
                        try {
                            mask = Integer.parseInt(ip[1]);
                            
                            if(mask<0 || mask>32)
                                out.println("<script>alert('M�scara (" + mask + ") inv�lida');</script>");
                            
                            else {
                                //  M�scara OK
                                
                                if(div>Math.pow(2, 32 - mask)) {
                                    out.println("<script>alert('Divis�o imposs�vel (Divis�o m�xima para /" + mask + ": " + ((long)Math.pow(2, 32 - mask)) + ")');</script>");
                                } else try {
                                    
                                    int b = 0;
                                    boolean validade = true;
                                    StringBuffer sb = new StringBuffer();
                                    
                                    out.print("\n\n<Div style='font-family: Consolas;'>");
                                    out.print("\n<!--\t Aqui est� a parte do Scriptlet que d� os resultados finais \t-->\n\n");
                                    
                                    for (int i=0; i<ip[0].length(); i++) {
                                        if(!Character.isDigit(ip[0].charAt(i))) {
                                            oct[c++] = Integer.parseInt(ip[0].substring(b, i));
                                            if(oct[c-1]<0 || oct[c-1]>=256) {
                                                if(!validade)
                                                    sb.append(", ");
                                                validade = false;
                                                sb.append(c + "�");
                                            } else {
                                                rede = rede + oct[c-1] + ".";
                                            }
                                            b = i+1;
                                        }
                                    }
                                    oct[c++] = Integer.parseInt(ip[0].substring(b));
                                    if(oct[c-1]<0 || oct[c-1]>=256) {
                                        if(!validade)
                                            sb.append(", ");
                                        validade = false;
                                        sb.append(c + "�");
                                    } else {
                                        rede = rede + oct[c-1] + "/" + mask;
                                    }
                                    
                                    /*
                                    for (String[] octetos = ip[0].split(""+separador); c<octetos.length; c++) {
                                        out.print(octetos[c]);
                                        oct[c] = Integer.parseInt(octetos[c]);
                                        out.print(oct[c]);
                                    }
                                    */
                                    
                                    if(!validade || c!=4) {
                                        out.println("<script>");
                                        out.print("alert('");
                                        if(!validade)
                                            out.print("Octeto (" + sb + ") inv�lido");
                                        if(c!=4)    //  Quantidade de Octetos Inv�lida
                                            out.print(((validade)?("Octetos"):(" e")) + " em quantidade inv�lida (" + c + ")");
                                        out.print("');");
                                        out.println("</script>");
                                    }
                                    
                                    else {
                                        //  Octetos OK
                                        
                                        Rede r = new Rede(oct, mask);
                                        
                                        if(r.ok()) {
                                            
                                            out.print(r + " dividida em " + div + " subrede");
                                            if(div>1)
                                                out.print("s");
                                            out.println(": ");
                                            out.println("<Br><Br>\n\n");
                                            
                                            Rede[] redes = r.subdividir(div);
                                            for(c=0; c<redes.length; c++)
                                                if(redes[c].ok())
                                                    out.println("\t" + (c+1) + ".\t <b>" + redes[c].getIp() + "</b>/<i>" + redes[c].getMask() + "</i>\t<br>");
                                            
                                            out.println("\n\n");
                                            
                                        } else {
                                            
                                            //  A rede informa problema de tamanho
                                            out.println("<script>alert('Tamanho de rede insuficiente');</script>");
                                            
                                        }
                                        
                                    }
                                    
                                    Calendar data = Calendar.getInstance();
                                    int day = data.get(Calendar.DAY_OF_MONTH);
                                    int month = data.get(Calendar.MONTH) + 1;
                                    int year = data.get(Calendar.YEAR) % 100;
                                    out.print("\n\n<!--\t ");
                                    if(day<10)
                                        out.print("0");
                                    out.print(day + "/");
                                    if(month<10)
                                        out.print("0");
                                    out.print(month + "/");
                                    if(year<10)
                                        out.print("0");
                                    out.print(year + " \t-->");
                                        //  N�o precisava de tudo isso para algo t�o simples,
                                        //  mas isso serve.
                                    out.print("\n</Div>");
                                    
                                } catch (NumberFormatException e) {
                                    //  Octeto
                                    out.println("<script>alert('" + (c+1) + "� Octeto decimal inv�lido');</script>");
                                }
                                
                            }
                            
                        } catch (ArrayIndexOutOfBoundsException i) {
                            //  M�scara Ausente
                            out.println("<script>alert('M�scara ausente');</script>");
                            
                        } catch (NumberFormatException e) {
                            //  M�scara n�o-num�rica
                            out.println("<script>alert('M�scara (" + ip[1] + ") n�o-num�rica');</script>");
                            
                        }
                    } catch (NumberFormatException e) {
                        /*
                            Devo assumir que n�o lembro para que serve esse tratamento de erro
                            Mas mantive o c�digo assim mesmo.
                        */
                    }
                    
                }
            } catch (NumberFormatException e) {
                //  Valor n�o-num�rico
                out.println("<h3>Aguardando requisi��o v�lida</h3>");
            }
            

        %>

    </BODY>

</HTML>