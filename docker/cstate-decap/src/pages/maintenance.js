import React from 'react'
import { graphql } from 'gatsby'

const MaintenancePage = ({ data }) => {
  const entries = data.allMarkdownRemark.edges;

  return (
    <div>
      <h1>Maintenance Alerts</h1>
      <ul>
        {entries.map(({ node }) => (
          <li key={node.id}>
            <h2>{node.frontmatter.title}</h2>
            <p>{node.frontmatter.date}</p>
            <div dangerouslySetInnerHTML={{ __html: node.html }} />
          </li>
        ))}
      </ul>
    </div>
  )
}

export const query = graphql`
  query {
    allMarkdownRemark(filter: { fileAbsolutePath: { regex: "/(content/maintenance)/" } }) {
      edges {
        node {
          id
          frontmatter {
            title
            date(formatString: "MMMM DD, YYYY")
          }
          html
        }
      }
    }
  }
`

export default MaintenancePage
