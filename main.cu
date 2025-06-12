#include <algorithm>
#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <getopt.h>
#include <cstdlib>

#include <polylla.cu>
#include <triangulation.cu>

int main(int argc, char **argv) {
    int opt;
    std::string node_file, ele_file, neigh_file, off_file, output;
    int size = 0;
    bool use_regions = false;

    while ((opt = getopt(argc, argv, "noir")) != -1) {
        switch (opt) {
            case 'n':
                if (argc != 6 && argc != 7) {
                    std::cerr << "Usage: " << argv[0] << " -n [-r] <node_file> <ele_file> <neigh_file> <output name>\n";
                    return 1;
                }
                node_file = argv[argc-4];
                ele_file = argv[argc-3];
                neigh_file = argv[argc-2];
                output = argv[argc-1];
                break;
            case 'o':
                if (argc != 4 && argc != 5) {
                    std::cerr << "Usage: " << argv[0] << " -o [-r] <off file> <output name>\n";
                    return 1;
                }
                off_file = argv[argc-2];
                output = argv[argc-1];
                break;
            case 'i':
                if (argc != 4) {
                    std::cerr << "Usage: " << argv[0] << " -i <size> <output name>\n";
                    return 1;
                }
                size = std::atoi(argv[2]);
                output = argv[3];
                break;
            case 'r':
                use_regions = true;
                break;
            default:
                std::cerr << "Usage: " << argv[0] << " [-n | -o | -i] args\n";
                return 1;
        }
    }

    if (!node_file.empty() && !ele_file.empty() && !neigh_file.empty()) {
        // Process node, ele, neigh files
        Polylla mesh(node_file, ele_file, neigh_file, use_regions);
        mesh.print_stats(output + ".json");
        mesh.print_OFF(output + ".off");
        std::cout << "output json in " << output << ".json" << std::endl;
        std::cout << "output off in " << output << ".off" << std::endl;

    } else if (!off_file.empty()) {
        // Process off file
        Polylla mesh(off_file, use_regions);
        mesh.print_stats(output + ".json");
        mesh.print_OFF(output + ".off");
        std::cout << "output json in " << output << ".json" << std::endl;
        std::cout << "output off in " << output << ".off" << std::endl;

    } else if (size > 0) {
        // Process size directly
        Polylla mesh(size);
        mesh.print_stats(output + ".json");
        mesh.print_OFF(output + ".off");
        std::cout << "output json in " << output << ".json" << std::endl;
        std::cout << "output off in " << output << ".off" << std::endl;
        
    } else {
        std::cerr << "Invalid arguments.\n";
        return 1;
    }

    return 0;
}