
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.swing.JOptionPane;
import org.mozilla.javascript.Context;
import org.mozilla.javascript.RhinoException;
import org.mozilla.javascript.ScriptableObject;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author teo.samarzija
 */
public class compileWindow extends javax.swing.JFrame {

    /**
     * Creates new form compileWindow
     */
    static String[] globalArgs;
    public compileWindow() {
        initComponents();
        if (!globalArgs[0].equals(new String())) {
                    jTextField1.setText(globalArgs[0]);
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextPane1 = new javax.swing.JTextPane();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Arithmetic Expression Compiler");

        jLabel1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel1.setText("Enter an arithmetic expression here and press Enter:");

        jTextField1.setText("1/(1+pow(abs(x),2)) ;x86 assembly doesn't support negative bases in 'pow'.");
        jTextField1.setToolTipText("");
        jTextField1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField1ActionPerformed(evt);
            }
        });

        jTextPane1.setEditable(false);
        jTextPane1.setBackground(new java.awt.Color(245, 245, 245));
        jTextPane1.setContentType("text/html"); // NOI18N
        jScrollPane1.setViewportView(jTextPane1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jScrollPane1)
                    .addComponent(jLabel1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jTextField1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 576, Short.MAX_VALUE))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 207, Short.MAX_VALUE)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    static public String getIEEE754(float x) {
        return String.format("<span style=\"color:#007700\">0x%x</span>", Float.floatToRawIntBits(x));
    }
    private void jTextField1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField1ActionPerformed
        // TODO add your handling code here:
        try {
            String compilerString=jTextField1.getText();
            compilerString = compilerString.replaceAll("\"", "'").replace("\\", "\\\\");
            Object thisClass=Context.javaToJS(this, mainWindow.scope);
            ScriptableObject.putProperty(mainWindow.scope, "compileWindow", thisClass);
            compilerString="var getIEEE754=compileWindow.getIEEE754;"+
                    "asm=function(x){assembler+=x+\"\\n\\n\\n\";};"+
                    "assembler=\"\\n\";"+
                    "highlight=true;"+
                    "finit();"+
                    "parseArth(tokenizeArth(\""+compilerString+"\")).compile();"+
                    "asm(\"fstp dword [result]\");"+
                    "syntaxHighlighting();"+
                    "assembler=assembler.replace(/\\n\\n*/g,\"\\n\");";
            mainWindow.cx.evaluateString(mainWindow.scope, compilerString, "", 0, null);
            String assembler=mainWindow.cx.evaluateString(mainWindow.scope, "assembler", "", 0, null).toString();
            assembler=assembler.replaceAll(";(.*)\n", "<span style=\"color:#777777\">;$1</span><br/>");
            assembler=assembler.replaceAll("ebx","<span style=\"color:#007777\">ebx</span>");
            assembler=assembler.replaceAll("\\[(.*)\\]","<span style=\"color:#770000\">[$1]</span>");
            assembler=assembler.replaceAll("this<", "this <");
            assembler=assembler.replaceAll("\'<","\' <");
            boolean isComment=false;
            String newAssembler=new String();
            for (int i=0; i<assembler.length(); i++) {
                if (assembler.substring(i, i+1).equals(";")) isComment=true;
                if (i<assembler.length()-"<br/>".length() 
                        && assembler.substring(i,i+"<br/>".length()).equals("<br/>")) isComment=false;
                if (isComment && i<assembler.length()-3
                        && (assembler.substring(i,i+3).equals("ebx")
                        || assembler.substring(i, i+3).equals("and")))
                {
                    newAssembler+="<span style=\"color:#777777\">"+assembler.substring(i,i+3)+"</span>";
                    i+=2;
                }
                else
                    newAssembler+=assembler.substring(i,i+1);
            }
            assembler=newAssembler;
            jTextPane1.setText(("<html><pre>"+
                    "<span style=\"color:#777777\">;Compile using FlatAssembler.<br/>"+
                    ";See https://flatassembler.github.io/compiler.html for more info.<br/>"+
                    ";If you want to include the Assembly into a C program,<br/>;I'd suggest you to also read:<br/>"+
                    ";https://flatassembler.github.io/quadratic.c</span><br/>"+
                    assembler+"</pre></html>").replaceAll("<br/>", "\n"));
        }
        catch (RhinoException exception) {
            JOptionPane.showMessageDialog(this, exception.details());
            mainWindow.cx = Context.enter();
            mainWindow.scope = mainWindow.cx.initStandardObjects();
            String compilerString = "";
            try {
                compilerString = new String(Files.readAllBytes(Paths.get("compiler.js")));
            } catch (IOException y) {
                JOptionPane.showMessageDialog(null,"The JavaScript file cannot be opened! "+y.getCause());
                System.exit(1);
            }
            mainWindow.cx.evaluateString(mainWindow.scope, compilerString, "", 0, null);
            mainWindow.cx.evaluateString(mainWindow.scope, "varijable['pi']=Math.PI;", compilerString, 0, null);
            mainWindow.cx.evaluateString(mainWindow.scope, "varijable['e']=Math.E;", compilerString, 0, null);
            mainWindow.cx.evaluateString(mainWindow.scope, "varijable['rad']=180/Math.PI;", compilerString, 0, null);
            mainWindow.cx.evaluateString(mainWindow.scope, "varijable['MV']=0;", compilerString, 0, null);
            mainWindow.cx.evaluateString(mainWindow.scope, "varijable['ANS']=0;", compilerString, 0, null);
        }
    }//GEN-LAST:event_jTextField1ActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(compileWindow.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(compileWindow.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(compileWindow.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(compileWindow.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        globalArgs=args;
        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new compileWindow().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextPane jTextPane1;
    // End of variables declaration//GEN-END:variables
}
