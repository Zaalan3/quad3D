import java.io.*;
import java.lang.reflect.Array;
import java.util.ArrayList;


public class OBJtoHeader {
    public static void main(String[] args) throws IOException {
        ArrayList<String> lines = new ArrayList<>();
        ArrayList<Vertex> verts = new ArrayList<>();
        ArrayList<TexCoord> texCoords = new ArrayList<>();
        ArrayList<Face> faces = new ArrayList<>();
        String name = (String) Array.get(args[0].split("\\."),0);
        // fetch lines
        BufferedReader in = new BufferedReader(new FileReader(args[0]));
        Object[] tempLines = in.lines().toArray();
        for(Object line : tempLines) {
            lines.add((String) line);
        }
        in.close();

        // output
        PrintWriter out = new PrintWriter(name + ".c");

        // fetch
        for(String line : lines) {
            String[] token = line.split("\\s+");

            if (token[0].compareToIgnoreCase("v")==0) {
                verts.add(new Vertex(token));
            } else if (token[0].compareToIgnoreCase("vt")==0) {
                texCoords.add(new TexCoord(token));
            } else if (token[0].compareToIgnoreCase("f")==0) {
                faces.add(new Face(token));
            }

        }

        for(Face f : faces) {
            f.setUV(texCoords);
        }

        // output
		out.println("#include <quad/quad.h>"); 
        out.println("//Model from " + args[0]);
        out.println(String.format("static qdVertex verts[%d];",verts.size()));
        out.println(String.format("static qdFace faces[%d];",faces.size()));
        out.println(String.format("qdObject %s = {0,0,0,%d,%d,verts,faces};",name,verts.size(),faces.size()));

        out.println(String.format("static qdFace faces[%d] = { ",faces.size()));
        for(int i = 0;i < faces.size();i++) {
            String temp = "\t"+faces.get(i).toString();
            if(i!=(faces.size()-1))
                temp += ",";
            out.println(temp);
        }
        out.println("};");

        out.println(String.format("static qdVertex verts[%d] = { ",verts.size()));
        for(int i = 0;i < verts.size();i++) {
            String temp = "\t"+verts.get(i).toString();
            if(i!=(verts.size()-1))
                temp += ",";
            out.println(temp);
        }
        out.println("};");

        out.close();

    }
}

class Vertex {
    private int x,y,z;

    public Vertex(String[] args)
    {
        // vertices stored with (128,128,128) as center
        x = 128 + (int)Math.round(Double.parseDouble(args[1]));
        y = 128 + (int)Math.round(Double.parseDouble(args[2]));
        z = 128 + (int)Math.round(Double.parseDouble(args[3]));
    }

    public String toString()
    {
        return String.format("{%d,%d,%d}",x,y,z);
    }

}

class TexCoord {
    public int u,v;

    public TexCoord(String[] args)
    {
        u = (int)(255.0*Double.parseDouble(args[1]));
        v = 127 - (int)(127.0*Double.parseDouble(args[2])); // blender measure v from bottom left
    }

}

class Face {
    private int[] vertex;
    private int texcoord;
    private int u,v;

    public Face(String[] args)
    {
        vertex = new int[4];
        String[] temp;
        // split line to get vertex indices
        temp = args[1].split("/");
        vertex[0] = Integer.parseInt(temp[0]) - 1;
        texcoord = Integer.parseInt(temp[1]) - 1; //only first tex coord counts

        temp = args[2].split("/");
        vertex[1] = Integer.parseInt(temp[0]) - 1;

        temp = args[3].split("/");
        vertex[2] = Integer.parseInt(temp[0]) - 1;

        // for triangles
        try {
            temp = args[4].split("/");
            vertex[3] = Integer.parseInt(temp[0]) - 1;
        } catch(IndexOutOfBoundsException e) {
            vertex[3] = vertex[2];
        }
    }

    public void setUV(ArrayList<TexCoord> arr) {
        u = arr.get(texcoord).u;
        v = arr.get(texcoord).v;
    }


    public String toString()
    {
        return String.format("{SHADER_TEXTURED,0xFF,0,0,%d,%d,%d,%d}",vertex[0],vertex[1],vertex[2],vertex[3]);
    }


}