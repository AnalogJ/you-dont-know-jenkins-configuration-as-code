package jcasc

import hudson.model.Item
import hudson.model.View

import jenkins.model.Jenkins
import org.junit.ClassRule
import org.jvnet.hudson.test.JenkinsRule
import spock.lang.Shared
import spock.lang.Specification
import spock.lang.Unroll
import groovy.io.FileType

import static java.util.Collections.emptyList;
import static java.util.Collections.singletonList;
import org.everit.json.schema.ValidationException;
import org.everit.json.schema.Schema;
import org.everit.json.schema.loader.SchemaLoader;
import org.json.JSONObject;
import org.json.JSONTokener;
import static io.jenkins.plugins.casc.misc.Util.validateSchema;
import static io.jenkins.plugins.casc.misc.Util.convertToJson;

/**
 * Tests that all dsl scripts in the jobs directory will compile. All config.xml's are written to build/debug-xml.
 *
 * This runs against the jenkins test harness. Plugins providing auto-generated DSL must be added to the build dependencies.
 */
class JCasCSpec extends Specification {

    @Shared
    @ClassRule
    private JenkinsRule jenkinsRule = new JenkinsRule()

    @Shared
    private File outputDir = new File('./build/debug-xml')

    def setupSpec() {
        outputDir.deleteDir()
    }

    @Unroll
    void 'test script #file.name'(File file) {

        given:
        def jcascConfig = new JSONObject(new JSONTokener(convertToJson(file.text)))
        print("========> PRINTING JCASC parsed config")
        print(jcascConfig)


        when:
        validateSchema(jcascConfig)

        then:
        noExceptionThrown()

        where:
        file << getJCasCFiles()

    }


    //Helper functions



    private List<File> getJCasCFiles() {
        List<File> files = []
        new File('.').eachFileRecurse(FileType.FILES) {
            if (it.name.endsWith('.yaml')) {
                files << it
            }
        }
        files
    }
}
