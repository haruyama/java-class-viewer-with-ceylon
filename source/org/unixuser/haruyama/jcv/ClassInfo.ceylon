import java.lang { ByteArray, IllegalStateException, JString = String }
import java.nio.file { Path, Paths, Files }
import java.util { List, ArrayList }

class ConstantPool(ByteArray bytes, List<Integer> list) {
    variable shared Integer cpsize = 0;

    Integer parseString(Integer index) {
        Integer size = list.get(index) * 256 + list.get(index + 1);
        JString string = JString(bytes, index + 2, size, "UTF-8");
        print("ConstantPool String: ``string``");
        return index + 2 + size;
    }

    shared Integer parse(Integer index, Integer count = 0) {
        if (count == cpsize - 1) {
            return index;
        }
        value tag = list.get(index);
        variable Integer parsedIndex = 0;
        switch(tag)
        case (1)  {
            parsedIndex = parseString(index + 1);
        }
        case (3)  {
            parsedIndex = index + 5;
        }
        case (4)  {
            parsedIndex = index + 5;
        }
        case (5)  {
            parsedIndex = index + 9;
        }
        case (6)  {
            parsedIndex = index + 9;
        }
        case (7)  {
            parsedIndex = index + 3;
        }
        case (8)  {
            parsedIndex = index + 3;
        }
        case (9)  {
            parsedIndex = index + 5;
        }
        case (10)  {
            parsedIndex = index + 5;
        }
        case (11)  {
            parsedIndex = index + 5;
        }
        case (12)  {
            parsedIndex = index + 5;
        }
        else {
            throw IllegalStateException();
        }

        return parse(parsedIndex, count + 1);
    }

}

shared class ClassInfo(String filename) {

    Integer signedByteToUnsigned(Integer b) {
        if(b < 0){
            return b + 256;
        }
        return b;
    }

    ByteArray slurp(String filename) {
        Path path = Paths.get(filename);
        return Files.readAllBytes(path);
    }


    value bytes  = slurp(filename);
    value list {
        value list = ArrayList<Integer>();
        for (i in 0:bytes.size) {
            list.add(signedByteToUnsigned(bytes.get(i)));
        }
        return list;
    }
    value constantPool = ConstantPool(bytes, list);

    Integer parseMagicNumber(Integer index) {
        assert(index == 0);
        assert(list.get(index) == #ca);
        assert(list.get(index + 1) == #fe);
        assert(list.get(index + 2) == #ba);
        assert(list.get(index + 3) == #be);
        return 4;
    }

    Integer parseVersionNumber(Integer index) {
        assert(index == 4);
        print("minor version: ``list.get(index)`` ``list.get(index + 1)``");
        print("major version: ``list.get(index + 2)`` ``list.get(index + 3)``");
        return 8;
    }

    Integer parseConstantPoolSize(Integer index) {
        assert(index == 8);
        Integer cpsize = list.get(index) * 256 + list.get(index + 1);
        print("constant pool size: ``cpsize``");
        constantPool.cpsize = cpsize;
        return 10;
    }

    shared void parse() {
        variable value index = 0;
        index = parseMagicNumber(index);
        index = parseVersionNumber(index);
        index = parseConstantPoolSize(index);
        index = constantPool.parse(index);
    }

}
