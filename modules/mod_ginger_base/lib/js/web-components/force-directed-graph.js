// Create a class for the element
class ForceDirectedGraph extends HTMLElement {
    constructor() {
        // Always call super first in constructor
        super();

        // Create a shadow root
        const shadow = this.attachShadow({
            mode: "closed"
        });

        // Get properties
        this.width = this.getAttribute("svg-width");
        this.height = this.getAttribute("svg-height");
        this.endpoint = this.getAttribute("endpoint");
        this.resourceId = this.getAttribute("resource-id");

        // Add the svg element to the shadow root.
        this.svg = d3.select(shadow).append("svg");

        this.svg
            .attr("width", this.width)
            .attr("height", this.height);
    }

    connectedCallback() {

        const color = d3.scaleOrdinal(d3.schemeCategory20);

        const simulation = d3.forceSimulation()
            .force("link", d3.forceLink().id(function (d) {
                return d.id;
            }))
            .force("charge", d3.forceManyBody())
            .force("center", d3.forceCenter(this.width / 2, this.height / 2));

        d3.json(`${this.endpoint}?id=${this.resourceId}`, function (error, graph) {
            if (error) throw error;

            console.log(graph)

            const link = this.svg.append("g")
                .attr("class", "links")
                .selectAll("line")
                .data(graph.links)
                .enter().append("line")
                .attr("stroke", "#ccc")
                .attr("stroke-width", function (d) {
                    return Math.sqrt(d.value);
                });

            const node = this.svg.append("g")
                .attr("class", "nodes")
                .selectAll("circle")
                .data(graph.nodes)
                .enter().append("circle")
                .attr("r", 6)
                .attr("fill", function (d) {
                    return color(d.group);
                })
                .call(d3.drag()
                    .on("start", dragstarted)
                    .on("drag", dragged)
                    .on("end", dragended));

            node.append("title")
                .text(function (d) {
                    return d.title;
                });

            simulation
                .nodes(graph.nodes)
                .on("tick", ticked);

            simulation.force("link")
                .links(graph.links);

            function ticked() {
                link
                    .attr("x1", function (d) {
                        return d.source.x;
                    })
                    .attr("y1", function (d) {
                        return d.source.y;
                    })
                    .attr("x2", function (d) {
                        return d.target.x;
                    })
                    .attr("y2", function (d) {
                        return d.target.y;
                    });

                node
                    .attr("cx", function (d) {
                        return d.x;
                    })
                    .attr("cy", function (d) {
                        return d.y;
                    });
            }
        }.bind(this));

        function dragstarted(d) {
            if (!d3.event.active) simulation.alphaTarget(0.3).restart();
            d.fx = d.x;
            d.fy = d.y;
        }

        function dragged(d) {
            d.fx = d3.event.x;
            d.fy = d3.event.y;
        }

        function dragended(d) {
            if (!d3.event.active) simulation.alphaTarget(0);
            d.fx = null;
            d.fy = null;
        }
    }
}

// Define the new element
customElements.define("force-directed-graph", ForceDirectedGraph);
