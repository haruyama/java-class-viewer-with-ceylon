import java.lang { IllegalArgumentException }
shared void run(){
    if (nonempty args=process.arguments) {
        for (arg in args) {
            value classInfo = ClassInfo(arg);
            classInfo.parse();
        }
    }
    else {
        throw IllegalArgumentException();
    }
}
